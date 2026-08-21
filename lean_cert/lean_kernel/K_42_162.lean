import Sound
import lean_certs.cert_42_162

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_162_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 42) (d := 162) (c := cert_42_162) (by decide)
