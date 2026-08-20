import Sound
import lean_certs.cert_47_104

open CertVerify

theorem H47_gt_104 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 47) (d := 104) (c := cert_47_104) (by native_decide)
