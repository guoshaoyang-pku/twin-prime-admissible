import Sound
import lean_certs.cert_13_38

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H13_gt_38_kernel : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 38 := by
  exact certValidRoot_sound (k := 13) (d := 38) (c := cert_13_38) (by decide)
