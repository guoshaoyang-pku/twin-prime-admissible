import Sound
import lean_certs.cert_23_88

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H23_gt_88_kernel : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 23) (d := 88) (c := cert_23_88) (by decide)
