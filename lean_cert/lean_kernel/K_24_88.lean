import Sound
import lean_certs.cert_24_88

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H24_gt_88_kernel : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 24) (d := 88) (c := cert_24_88) (by decide)
