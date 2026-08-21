import Sound
import lean_certs.cert_46_182

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_182_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 182 := by
  exact certValidRoot_sound (k := 46) (d := 182) (c := cert_46_182) (by decide)
