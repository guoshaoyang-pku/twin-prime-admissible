import Sound
import lean_certs.cert_34_88

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_88_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 34) (d := 88) (c := cert_34_88) (by decide)
