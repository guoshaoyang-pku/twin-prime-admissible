import Sound
import lean_certs.cert_45_104

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_104_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 45) (d := 104) (c := cert_45_104) (by decide)
