import Sound
import lean_certs.cert_10_26

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H10_gt_26_kernel : ¬ ∃ t : List Nat, admissible 10 t = true ∧ diameter t ≤ 26 := by
  exact certValidRoot_sound (k := 10) (d := 26) (c := cert_10_26) (by decide)
