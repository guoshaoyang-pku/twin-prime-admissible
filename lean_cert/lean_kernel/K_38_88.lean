import Sound
import lean_certs.cert_38_88

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_88_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 38) (d := 88) (c := cert_38_88) (by decide)
