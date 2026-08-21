import Sound
import lean_certs.cert_40_182

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H40_gt_182_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 182 := by
  exact certValidRoot_sound (k := 40) (d := 182) (c := cert_40_182) (by decide)
