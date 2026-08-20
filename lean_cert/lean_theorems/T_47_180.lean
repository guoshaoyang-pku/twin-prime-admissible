import Sound
import lean_certs.cert_47_180

open CertVerify

theorem H47_gt_180 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 47) (d := 180) (c := cert_47_180) (by native_decide)
