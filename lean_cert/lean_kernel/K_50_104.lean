import Sound
import lean_certs.cert_50_104

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_104_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 50) (d := 104) (c := cert_50_104) (by decide)
