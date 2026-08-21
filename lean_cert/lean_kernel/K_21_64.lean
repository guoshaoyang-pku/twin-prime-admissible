import Sound
import lean_certs.cert_21_64

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H21_gt_64_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 21) (d := 64) (c := cert_21_64) (by decide)
