import Sound
import lean_certs.cert_23_52

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H23_gt_52_kernel : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 52 := by
  exact certValidRoot_sound (k := 23) (d := 52) (c := cert_23_52) (by decide)
