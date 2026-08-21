import Sound
import lean_certs.cert_28_88

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_88_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 28) (d := 88) (c := cert_28_88) (by decide)
