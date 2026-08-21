import Sound
import lean_certs.cert_21_52

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H21_gt_52_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 52 := by
  exact certValidRoot_sound (k := 21) (d := 52) (c := cert_21_52) (by decide)
