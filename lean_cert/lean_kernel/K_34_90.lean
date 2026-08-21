import Sound
import lean_certs.cert_34_90

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_90_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 34) (d := 90) (c := cert_34_90) (by decide)
