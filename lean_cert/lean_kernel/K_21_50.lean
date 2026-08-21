import Sound
import lean_certs.cert_21_50

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H21_gt_50_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 50 := by
  exact certValidRoot_sound (k := 21) (d := 50) (c := cert_21_50) (by decide)
