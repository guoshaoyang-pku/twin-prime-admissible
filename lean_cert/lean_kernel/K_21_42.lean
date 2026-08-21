import Sound
import lean_certs.cert_21_42

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H21_gt_42_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 42 := by
  exact certValidRoot_sound (k := 21) (d := 42) (c := cert_21_42) (by decide)
