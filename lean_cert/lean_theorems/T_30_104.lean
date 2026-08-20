import Sound
import lean_certs.cert_30_104

open CertVerify

theorem H30_gt_104 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 30) (d := 104) (c := cert_30_104) (by native_decide)
