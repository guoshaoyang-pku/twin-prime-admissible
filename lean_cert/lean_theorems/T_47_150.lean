import Sound
import lean_certs.cert_47_150

open CertVerify

theorem H47_gt_150 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 47) (d := 150) (c := cert_47_150) (by native_decide)
