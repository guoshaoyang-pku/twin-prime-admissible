import Sound
import lean_certs.cert_42_190

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H42_gt_190_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 190 := by
  exact certValidRoot_sound (k := 42) (d := 190) (c := cert_42_190) (by decide)
