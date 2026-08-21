import Sound
import lean_certs.cert_29_104

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_104_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 29) (d := 104) (c := cert_29_104) (by decide)
