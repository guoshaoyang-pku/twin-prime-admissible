import Sound
import lean_certs.cert_17_52

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H17_gt_52_kernel : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 52 := by
  exact certValidRoot_sound (k := 17) (d := 52) (c := cert_17_52) (by decide)
