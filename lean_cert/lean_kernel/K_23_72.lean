import Sound
import lean_certs.cert_23_72

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H23_gt_72_kernel : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 23) (d := 72) (c := cert_23_72) (by decide)
