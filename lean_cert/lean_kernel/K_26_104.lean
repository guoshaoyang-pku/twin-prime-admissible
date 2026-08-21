import Sound
import lean_certs.cert_26_104

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_104_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 26) (d := 104) (c := cert_26_104) (by decide)
