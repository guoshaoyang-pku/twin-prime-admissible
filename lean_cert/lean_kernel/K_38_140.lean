import Sound
import lean_certs.cert_38_140

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_140_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 38) (d := 140) (c := cert_38_140) (by decide)
