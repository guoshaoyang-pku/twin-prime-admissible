import Sound
import lean_certs.cert_28_84

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_84_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 28) (d := 84) (c := cert_28_84) (by decide)
