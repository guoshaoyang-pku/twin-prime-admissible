import Sound
import lean_certs.cert_19_52

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H19_gt_52_kernel : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 52 := by
  exact certValidRoot_sound (k := 19) (d := 52) (c := cert_19_52) (by decide)
