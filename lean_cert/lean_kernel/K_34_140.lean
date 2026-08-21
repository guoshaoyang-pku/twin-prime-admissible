import Sound
import lean_certs.cert_34_140

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_140_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 34) (d := 140) (c := cert_34_140) (by decide)
