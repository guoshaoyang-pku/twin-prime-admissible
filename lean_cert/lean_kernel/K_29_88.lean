import Sound
import lean_certs.cert_29_88

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_88_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 29) (d := 88) (c := cert_29_88) (by decide)
