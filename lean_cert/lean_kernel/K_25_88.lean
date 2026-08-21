import Sound
import lean_certs.cert_25_88

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_88_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 25) (d := 88) (c := cert_25_88) (by decide)
