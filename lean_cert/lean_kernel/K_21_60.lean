import Sound
import lean_certs.cert_21_60

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H21_gt_60_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 60 := by
  exact certValidRoot_sound (k := 21) (d := 60) (c := cert_21_60) (by decide)
