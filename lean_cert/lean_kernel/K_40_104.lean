import Sound
import lean_certs.cert_40_104

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_104_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 40) (d := 104) (c := cert_40_104) (by decide)
