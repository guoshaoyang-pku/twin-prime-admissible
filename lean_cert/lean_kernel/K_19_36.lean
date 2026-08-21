import Sound
import lean_certs.cert_19_36

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H19_gt_36_kernel : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 36 := by
  exact certValidRoot_sound (k := 19) (d := 36) (c := cert_19_36) (by decide)
