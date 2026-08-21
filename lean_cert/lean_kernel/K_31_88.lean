import Sound
import lean_certs.cert_31_88

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H31_gt_88_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 31) (d := 88) (c := cert_31_88) (by decide)
