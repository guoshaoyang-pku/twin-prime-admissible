import Sound
import lean_certs.cert_42_146

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_146_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 42) (d := 146) (c := cert_42_146) (by decide)
