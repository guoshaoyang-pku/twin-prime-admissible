import Sound
import lean_certs.cert_19_38

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H19_gt_38_kernel : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 38 := by
  exact certValidRoot_sound (k := 19) (d := 38) (c := cert_19_38) (by decide)
