import Sound
import lean_certs.cert_40_88

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_88_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 40) (d := 88) (c := cert_40_88) (by decide)
