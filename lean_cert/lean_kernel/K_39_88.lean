import Sound
import lean_certs.cert_39_88

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_88_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 39) (d := 88) (c := cert_39_88) (by decide)
