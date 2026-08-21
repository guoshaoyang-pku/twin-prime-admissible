import Sound
import lean_certs.cert_19_56

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H19_gt_56_kernel : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 56 := by
  exact certValidRoot_sound (k := 19) (d := 56) (c := cert_19_56) (by decide)
