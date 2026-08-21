import Sound
import lean_certs.cert_34_84

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_84_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 34) (d := 84) (c := cert_34_84) (by decide)
