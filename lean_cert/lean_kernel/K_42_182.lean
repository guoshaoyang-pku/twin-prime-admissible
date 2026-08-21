import Sound
import lean_certs.cert_42_182

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H42_gt_182_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 182 := by
  exact certValidRoot_sound (k := 42) (d := 182) (c := cert_42_182) (by decide)
