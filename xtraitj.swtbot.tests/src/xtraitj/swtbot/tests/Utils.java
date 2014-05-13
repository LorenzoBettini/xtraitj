/*
 * Copyright (c) 2005, 2010 Borland Software Corporation and others
 * 
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Artem Tikhomirov (Borland) - initial API and implementation
 *    Mickael Istria (EBM Websourcing) - Support for target platform creation
 */
package xtraitj.swtbot.tests;

import java.io.File;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.eclipse.core.runtime.Platform;
import org.eclipse.core.runtime.jobs.Job;
import org.eclipse.osgi.baseadaptor.BaseData;
import org.eclipse.osgi.framework.internal.core.AbstractBundle;
import org.eclipse.pde.core.target.ITargetDefinition;
import org.eclipse.pde.core.target.ITargetLocation;
import org.eclipse.pde.core.target.ITargetPlatformService;
import org.eclipse.pde.core.target.LoadTargetDefinitionJob;
import org.eclipse.pde.internal.core.target.TargetPlatformService;
import org.osgi.framework.Bundle;

/**
 * Implements workaround suggested here:
 * https://bugs.eclipse.org/bugs/show_bug.cgi?id=343156
 * 
 * @author artem
 * @author Lorenzo Bettini - some adaptations
 */
public class Utils {

	/**
	 * Sets a target platform in the test platform to get workspace builds OK
	 * with PDE.
	 * 
	 * @throws Exception
	 */
	public static void setTargetPlatform() throws Exception {
		ITargetPlatformService tpService = TargetPlatformService.getDefault();
		ITargetDefinition targetDef = tpService.newTarget();
		targetDef.setName("Tycho platform");
		Bundle[] bundles = Platform.getBundle("org.eclipse.core.runtime").getBundleContext().getBundles();
		List<ITargetLocation> bundleContainers = new ArrayList<ITargetLocation>();
		Set<File> dirs = new HashSet<File>();
		System.out.println("Bundles for the target platform:");
		for (Bundle bundle : bundles) {
			System.out.print(bundle);
			AbstractBundle bundleImpl = (AbstractBundle) bundle;
			BaseData bundleData = (BaseData) bundleImpl.getBundleData();
//			EquinoxBundle bundleImpl = (EquinoxBundle) bundle;
//			Generation generation = (Generation) bundleImpl.getModule().getCurrentRevision().getRevisionInfo();
			File file = bundleData.getBundleFile().getBaseFile();
			File folder = file.getParentFile();
			if (!dirs.contains(folder)) {
				dirs.add(folder);
				bundleContainers.add(tpService.newDirectoryLocation(folder.getAbsolutePath()));
			}
		}
		System.out.println("Bundles added the target platform.");
		targetDef.setTargetLocations(bundleContainers.toArray(new ITargetLocation[bundleContainers.size()]));
		targetDef.setArch(Platform.getOSArch());
		targetDef.setOS(Platform.getOS());
		targetDef.setWS(Platform.getWS());
		targetDef.setNL(Platform.getNL());
		// targetDef.setJREContainer()
		tpService.saveTargetDefinition(targetDef);

		System.out.print("Loading target platform... ");
		Job job = new LoadTargetDefinitionJob(targetDef);
		job.schedule();
		job.join();
		System.out.println("DONE.");
	}
}
