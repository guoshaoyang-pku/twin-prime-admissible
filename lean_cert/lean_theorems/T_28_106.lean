import Sound
import lean_certs.cert_28_106

open CertVerify

theorem H28_gt_106 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 28) (d := 106) (c := cert_28_106) (by native_decide)
