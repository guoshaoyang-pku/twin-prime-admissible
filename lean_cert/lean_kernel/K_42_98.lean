import Sound
import lean_certs.cert_42_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_98_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 42) (d := 98) (c := cert_42_98) (by decide)
