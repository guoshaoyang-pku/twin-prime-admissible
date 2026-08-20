import Sound
import lean_certs.cert_39_104

open CertVerify

theorem H39_gt_104 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 39) (d := 104) (c := cert_39_104) (by native_decide)
