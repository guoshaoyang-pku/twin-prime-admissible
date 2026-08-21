import Sound
import lean_certs.cert_30_84

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_84_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 30) (d := 84) (c := cert_30_84) (by decide)
