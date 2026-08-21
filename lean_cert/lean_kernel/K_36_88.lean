import Sound
import lean_certs.cert_36_88

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_88_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 36) (d := 88) (c := cert_36_88) (by decide)
