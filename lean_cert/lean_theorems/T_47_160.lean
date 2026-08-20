import Sound
import lean_certs.cert_47_160

open CertVerify

theorem H47_gt_160 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 47) (d := 160) (c := cert_47_160) (by native_decide)
