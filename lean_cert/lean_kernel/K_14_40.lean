import Sound
import lean_certs.cert_14_40

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H14_gt_40_kernel : ¬ ∃ t : List Nat, admissible 14 t = true ∧ diameter t ≤ 40 := by
  exact certValidRoot_sound (k := 14) (d := 40) (c := cert_14_40) (by decide)
