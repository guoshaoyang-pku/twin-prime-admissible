import Sound
import lean_certs.cert_10_18

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H10_gt_18_kernel : ¬ ∃ t : List Nat, admissible 10 t = true ∧ diameter t ≤ 18 := by
  exact certValidRoot_sound (k := 10) (d := 18) (c := cert_10_18) (by decide)
