import Sound
import lean_certs.cert_30_88

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_88_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 30) (d := 88) (c := cert_30_88) (by decide)
